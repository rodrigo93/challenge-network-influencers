# NuBinary's Code Challenge

This repository contains NuBinary's code challenge for a Ruby on Rails position.

## Tech stack

- Ruby 3.2.0
- Rspec

## Challenge description

We are going to find the most influential people in the in-it network. Each user in in-it follows a group of zero or
more people. The list of "followings" are given to us as an array of pairs. Each pair is in the form of `[x, y]` which
means the user with username `x` is following the user with username `y`.

A user X influences a user Y if
- Y follows X, or
- Y follows one of the users that X influences

**Also, a user cannot follow herself.**

The output should be the list of username of the users that each influence the most number of people in the network and
no one else influences that many users that they each do. For example, suppose Ross, Monica, Phoebe, Joey, Rachel and
Chandler are the in-it users and the input is given as follows:

```ruby
[
  ['Ross', 'Monica'],
  ['Ross', 'Rachel'],
  ['Rachel', 'Monica'],
  ['Joey', 'Phoebe'],
  ['Chandler', 'Joey'],
  ['Ross', 'Chandler'],
  ['Chandler', 'Ross']
]
```

Then **Monica** influences Rachel, Ross and Chandler. **Phoebe** influences Joey, Chandler and Ross. No one else in the
network influences 3 or more people, therefore **Monica** and **Phoebe** are the most influential people in the network
and a correct output would be `['Monica', 'Phoebe']`

Write the body of the `find_influencers` method that gets a list of followings as input and returns the list of most
influential users in the network.

Once complete, hit 'run' to test your method against sample inputs

## Running the solution

_TODO_