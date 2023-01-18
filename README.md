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

![followers_illustration.png](imgs%2Ffollowers_illustration.png)

Write the body of the `find_influencers` method that gets a list of followings as input and returns the list of most
influential users in the network.

Once complete, hit 'run' to test your method against sample inputs

## Running the solution


First you need to install all dependencies by running
### `bundle install`

Then, to run the solution run the following command in your terminal from this directory
### `ruby src/update_challenge.rb`

## Notes from the author

From the description and after writing down the challenge, it looks like a [Graph Theory][GF] issue with directed graphs.
The **user** is a **node** and the **relationship** are the **edges/link**.
It's known that Graph Theory has many [algorithms that solve different problems][Algorithms].

The last time I've worked with Graphs was back in the undergrad days during the Graphs chair 🥲 (more than 6 years ago).
Even though, after reading through the algorithms again, [Depth-first search][DFS] sounds like a good fit for this
problem:

> Depth-first search (DFS) is an algorithm for traversing or searching tree or graph data structures.
> The algorithm starts at the root node (selecting some arbitrary node as the root node in the case of a graph) and
> **_explores as far as possible along each branch before backtracking._**

Does that last sentence ring any bells? From the illustrated graph, for each node, we want to know
as far it can go (influences). So, let's give it a try!

### First try

First try was not simple, as I had to normalize the input and prepare the field for
the custom DFS.

My first solution went quite well, **scoring 23 out 26** from the existing "solution checker".
Problem is, my solution is not taking into consideration influencer's followers also
following among themselves.

The image below shows the DFS running for **Monica**, and the dotted lines are the iterations.
The red lines are the iterations that should not happen, as they are generating false positives.
E.g when checking for **Rachel**, **Ross** is the only follower and should not be visited anymore
nor increase Monica's influencer count.

![first_solution.png](imgs%2Ffirst_solution.png)

Given that, we need to improve our solution.

### Second try

False positives are handled. I decided to change the swap the `influencers_count` — a simple counter that would sum
up every time a not visited node is visited — by `influencers_reach` a `Set` object from the [set][SetGem] gem.
This alternative is very handy as `Set` already takes care of duplicates and now the amount of people influenced by
a user is accounted outside of DFS.

Although, the score still 23 out 26 🤔. Why's that? I don't know, I need to dig further.

[Algorithms]:https://en.wikipedia.org/wiki/Graph_theory#Algorithms
[DFS]:https://en.wikipedia.org/wiki/Depth-first_search
[GF]:https://en.wikipedia.org/wiki/Graph_theory
[SetGem]:https://github.com/ruby/set