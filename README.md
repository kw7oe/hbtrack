# Hbtrack
[![Gem Version](https://badge.fury.io/rb/hbtrack.svg)](https://badge.fury.io/rb/hbtrack)
[![Build Status](https://travis-ci.org/kw7oe/hbtrack.svg?branch=master)](https://travis-ci.org/kw7oe/hbtrack)
[![Code Climate](https://codeclimate.com/github/kw7oe/hbtrack/badges/gpa.svg)](https://codeclimate.com/github/kw7oe/hbtrack)
[![Test Coverage](https://codeclimate.com/github/kw7oe/hbtrack/badges/coverage.svg)](https://codeclimate.com/github/kw7oe/hbtrack/coverage)


`hbtrack` is a simple command lines tool to keep track of your daily habits.

## Installation

```
gem install hbtrack
```

## Usage
```
Usage: hbtrack <command> [<habit_name>] [options]

Commands:
     add: Add habit(s)
     remove: Remove habit(s)
     list: List habit(s)
     show: Show habit
     done: Mark habit(s) as done
     undone: Mark habit(s) as undone
     import: Import data from files

Options:
     -h, --help   Show help messages of the command
```

For more details, `hbtrack <command> --help`

## Data

### For version `>= 0.0.7`
The data are  stored in `sqlite3` database, which is located at `~/.habit.db`. So if you have updated to the latest version, you can import your data from `.habit` by using the commnd `hbtrack import 'YOUR_HOME_DIRECTORY/.habit'`

### For version prior to `0.0.7`
The data is stored in your home directory, in file named `.habit`. In Unix/Unix-like system, you can directly edit the file by:

```
vim ~/.habit

```

All the data is stored in the form of:

```
workout
2017,6: 111111100000110100110000000001
2017,7: 11111111111111111111
```

The first line represent the name of the habit. The second rows onward represent the progress of the habit for each month. More details:

* `2017,6` represent your progress during June 2017.
* `1` is used to represent done.
* `0` is used to represent undone.
* Black space is used to represent not recorded/dayoff.
* Each habit is seperated by a newline. For example:

```
workout
2017,7: 11111111111111111111

read
2017,7: 11111111111110011111
```

## Bugs/Features
The project is still under development.

If there are any bugs/features request, feel free to create a new issues.


