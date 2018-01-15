# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::Importer::StreaksImporter do
  let(:csv) do
    <<~CSV
    task_id,title,entry_type,entry_date,entry_timestamp,page,display_order
    p2,"Wake Up Before 7.30",missed_auto,20170225,2017-02-26T12:24:16+08:00,1,1
    p2,"Wake Up Before 7.30",missed_auto,20170226,2017-02-27T09:37:49+08:00,1,1
    p2,"Wake Up Before 7.30",missed_auto,20170227,2017-02-28T06:36:25+08:00,1,1
    p2,"Wake Up Before 7.30",missed_auto,20170228,2017-03-01T07:55:36+08:00,1,1
    CSV
  end
  let(:file) do
    require 'tempfile'
    f = Tempfile.open(['streaks', 'csv'])
    f.write(csv)
    f.close
    f
  end
  let(:importer) { Hbtrack::Importer::StreaksImporter.new }

  it 'should parse streaks.csv correctly' do
    habits, entries = importer.import_from(file.path)

    expect(habits.count).to eq 1
    expect(entries.count).to eq 1

    habit = habits['p2']
    entry = entries['p2'].first
    expect(habit.title).to eq 'Wake Up Before 7.30'
    expect(entry.timestamp).to eq '2017-02-26T12:24:16+08:00'
  end

  describe 'storage' do
    after { File.delete('test.db') }

    # TODO: Migrate test to somewhere related
    it 'should transfer result into storage accordingly' do
      store = Hbtrack::Database::SequelStore.new(name: 'test.db')
      importer.import_from(file.path)
      importer.store_in(store)

      habit = store.get_habit(1)
      entries = store.get_entries_of_month(1, 2, 2017)

      expect(entries.first[:type]).to eq 'missed_auto'
      expect(entries.last[:type]).to eq 'missed_auto'
      expect(entries.count).to eq 3
      expect(habit[:title]).to eq 'Wake Up Before 7.30'
    end
  end

end
