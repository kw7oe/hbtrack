## Hbtrack

`hbtrack` is a simple Command Lines tool to keep track of your daily habits. The functionality of the current version is very limited.

## Installation

```
gem install hbtrack
```

## Usage

To add a new habit _(duplicate name will be ignore)_: `hbtrack add habit_name`

To mark your habit as done for the current day: `hbtrack done habit_name`

To mark your habit as undone for the current day: `hbtrack undone habit_name`

You can also mark your habit done/undone for the previous day by adding `-y` option: `hbtrack done/undone -y habit_name`

To remove the habit completely: `hbtrack remove habit_name`

To have a look of all of your habit progress: `hbtrack list `

To look at individual habit progress: `hbtrack list habit_name`

## Limitations

For the current version, some invalid inputs are not handled properly.

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
If there are any bugs/feature requesst, feel free to create a new issues.




