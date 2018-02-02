# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hbtrack::CLI do
  let(:store) { Hbtrack::Database::SequelStore.new(name: 'test.db') }

  describe '#run' do
    before do
      habit1 = Habit.new('workout', 1)
      habit2 = Habit.new('read', 2)
      entry1 = Entry.new('2017-01-01T12:24:16+08:00', 'missed')
      entry2 = Entry.new('2017-01-02T12:24:16+08:00', 'partially_completed')
      store.add_habit(habit1)
      store.add_habit(habit2)
      store.add_entry_of(1, entry1)
      store.add_entry_of(2, entry1)
      store.add_entry_of(1, entry2)
      store.add_entry_of(2, entry2)
    end
    after do
      File.delete('test.db')
    end

    it 'list command should work' do
      expect { Hbtrack::CLI.run('test.db', ['list']) }
        .to output(Hbtrack::ListCommand.new('test.db', []).execute + "\n")
        .to_stdout
    end

    it 'show command should work' do
      args = ['show', 'read']
      expect { Hbtrack::CLI.run('test.db', args) }
        .to output(Hbtrack::ShowCommand.new('test.db', args.last).execute + "\n")
        .to_stdout
    end

    it 'done command should work' do
      args = ['done', 'read']
      expect { Hbtrack::CLI.run('test.db', args) }
        .to output(Hbtrack::UpdateCommand.new('test.db', args.last, true).execute +
      "\n").to_stdout
    end

    it 'undone command should work' do
      args = ['undone', 'read']
      expect { Hbtrack::CLI.run('test.db', args) }
        .to output(Hbtrack::UpdateCommand.new('test.db', args.last, false).execute +
      "\n").to_stdout
    end

    it 'remove command should work' do
      expect { Hbtrack::CLI.run('test.db', ['remove', 'read']) }
        .to output(Hbtrack::Util.blue('Remove read!') + "\n")
        .to_stdout
    end

    it 'add command should work' do
      args = ['add', 'apple']
      expect { Hbtrack::CLI.run('test.db', args) }
        .to output(Hbtrack::Util.green('Add apple!') + "\n")
        .to_stdout
    end

    it 'import command should work' do
      args = ['import', 'test/test_data']
      expect { Hbtrack::CLI.run('test.db', args) }
        .to output(Hbtrack::Util.green('Succesfully imported from test/test_data') + "\n")
        .to_stdout
    end
  end

  describe '#help' do
    it 'should display help message' do
      expect { Hbtrack::CLI.help }.to output(//).to_stdout
        .and raise_error SystemExit
    end
  end
end
