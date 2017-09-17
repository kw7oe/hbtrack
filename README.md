# Hbtrack [![Gem Version](https://badge.fury.io/rb/hbtrack.svg)](https://badge.fury.io/rb/hbtrack) [![Build Status](https://travis-ci.org/kw7oe/hbtrack.svg?branch=master)](https://travis-ci.org/kw7oe/hbtrack)

`hbtrack` is a simple command lines tool to keep track of your daily habits. The functionality of the current version is very limited.

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
     done: Mark habit(s) as done
     undone: Mark habit(s) as undone

Options:
     -h, --help   Show help messages of the command
```

**Note:** For more details about available options for each command, type `hbtrack <command> -h` 

## Features
- [x] List all habits
  - with completion rate or total/done/undone count
- [x] Add single or multiple habits at once
- [x] Mark:
  - single or mutiple habits as done/undone
  - remaining habits of as done/undone
  - habit(s) as done for specific day with `--day DAY`
- [x] Remove single or multiple habits at once
- [ ] Generate report in HTML format. *(In Progress)*

## Output

### List all habits:
```
August 2017
-----------
1. workout     : ***                             All: 3, Done: 3, Undone: 0
2. read        : ***                             All: 3, Done: 3, Undone: 0
3. programming : ***                             All: 3, Done: 3, Undone: 0
4. ukulele     : ***                             All: 3, Done: 3, Undone: 0
5. sleep_early : ***                             All: 3, Done: 1, Undone: 2

Total
-----
All: 15, Done: 13, Undone: 2
```

**Note:** The actual output is colorized where green color font indicate done and red color font indicate undone.

### List a habit:
```
workout
-------
     July 2017 : ******************************* All: 31, Done: 26, Undone: 5
   August 2017 : ***                             All: 3, Done: 3, Undone: 0
```

### List all habits with `-p`:

Extra options such as `-p` or `--percentage` can be provided to list the stats of your habits in terms of completion rate.


```
August 2017
-----------
1. workout     : ***                             Completion rate: 100.00%
2. read        : ***                             Completion rate: 100.00%
3. programming : ***                             Completion rate: 100.00%
4. ukulele     : ***                             Completion rate: 100.00%
5. sleep_early : ***                             Completion rate: 33.33%

Total
-----
Completion rate: 86.67%
```

## Data

All the data is stored in your home directory, in a hidden file named `.habit`. In Unix/Unix-like system, you can directly edit the file by:

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




