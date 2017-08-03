## Hbtrack

`hbtrack` is a simple command lines tool to keep track of your daily habits. The functionality of the current version is very limited.

## Installation

```
gem install hbtrack
```

## Usage

#### Add a new habit
```
$ hbtrack add habit_name
```
Duplicate habit name will be ignore. 

#### Mark habit as done/undone
```
$ hbtrack done habit_name
```
This will mark the current habit as done for the current day. 

```
$ hbtrack undone habit_name
```
This will mark the current habit as undone for the current day.

You can also mark your habit done/undone for the previous day by adding `-y` or `--yesterday` option: 
```
$ hbtrack done/undone -y habit_name
```

#### Remove a habit 
```
$ hbtrack remove habit_name
```

#### Listing Progress

You can list all your habits progress by: 
```
$ hbtrack list 
```
This will list all the habits you added and its progress for the current month.

**Output:** 
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

You can also look at the progress of an individual habit by: 
```
$ hbtrack list habit_name
```

**Output:**
```
workout
-------
     July 2017 : ******************************* All: 31, Done: 26, Undone: 5
   August 2017 : ***                             All: 3, Done: 3, Undone: 0
```


Extra options such as `-p` or `--percentage` can be provided to list the stats of your habits in terms of completion rate.
```
$ hbtrack list -p habit_name
```

With the extra options `-p`, the output will be:
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
* Each habit is seperated by a newline. For example:

```
workout
2017,7: 11111111111111111111

read
2017,7: 11111111111110011111
```

## Bugs/Features
The project is still in development. 

If there are any bugs/features request, feel free to create a new issues.




