# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Importer::HbtrackImporter do
  let(:content) do
    <<~CONTENT
    workout
    2017,9: 011111111111111011111111111111
    2017,10: 1101001011010101111111111111001
    2017,11: 110111111111110110110101111110
    2017,12: 11110101101111

    read
    2017,9: 111111111111111111111111111111
    2017,10: 1111111111100111111111111111011
    2017,11: 110111111111110110011101111111
    2017,12: 1111011111111
    CONTENT
  end
  let(:file) do
    require 'tempfile'
    f = Tempfile.open(['.habit'])
    f.write(content)
    f.close
    f
  end
  let(:importer) { Hbtrack::Importer::HbtrackImporter.new }

  it 'should parse .habit correctly' do
    habits, entries = importer.import_from(file.path)

    expect(habits.count).to eq 2
    expect(entries.count).to eq 2

    habit = habits[0]
    entry = entries[0].first
    time_zone = Time.new(2017,9,1).iso8601
    expect(habit.title).to eq 'workout'
    expect(entry.timestamp).to eq time_zone
  end

  describe 'storage' do
    after { File.delete('test.db') }

    # TODO: Migrate test to somewhere related
    it 'should transfer result into storage accordingly' do
      store = Hbtrack::Database::SequelStore.new(name: 'test.db')
      importer.import_from(file.path)
      importer.store_in(store)

      habit = store.get_habit(1)
      entries = store.get_entries_of_month(1, 10, 2017)

      expect(habit[:title]).to eq 'workout'
      expect(entries.first[:type]).to eq 'completed'
      expect(entries.last[:type]).to eq 'completed'
      expect(entries.count).to eq 31
    end
  end

end
