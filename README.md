## Hbtrack

`hbtrack` is a simple Command Lines tool to keep track of your daily habits. The functionality of the current version is very limited.

## Installation

```
gem install hbtrack
```

## Usage

To add a new habit _(duplicate name will be ignore)_:
```
hbtrack add habit_name
```

To mark your habit as done for the current day:
```
hbtrack done habit_name
```

To mark your habit as undone for the current day:
```
hbtrack undone habit_name
```

You can also mark your habit done/undone for the previous day by adding `-y` option:
```
hbtrack done/undone -y habit_name
```

To remove the habit completely:
```
hbtrack remove habit_name
```

To have a look of all of your habit progress:
```
hbtrack list 
```

To look at individual habit progress:
```
hbtrack list habit_name
```

## Contact
If there is any bugs/feature requesst, feel free to create a new issues.




