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

## Third try

To start understanding why some scenarios are still failing, I took one of the **problematic input**, **expected output**
and **current output** to analyse:

```ruby
input = [
  ["user2", "user7"],
  ["user2", "user8"],
  ["user2", "user13"],
  ["user3", "user5"],
  ["user3", "user12"],
  ["user5", "user2"],
  ["user5", "user4"],
  ["user6", "user2"],
  ["user9", "user6"],
  ["user10", "user11"],
  ["user11", "user1"],
  ["user11", "user7"],
  ["user11", "user12"],
  ["user12", "user2"],
  ["user12", "user4"],
  ["user12", "user6"],
  ["user12", "user10"],
  ["user13", "user1"],
  ["user13", "user3"]
]

expected_output = ["user1", "user4", "user7", "user8"]

current_output = [
  "user1",
  "user10",
  "user11",
  "user12",
  "user13",
  "user2",
  "user3",
  "user4",
  "user5",
  "user6",
  "user7",
  "user8"
]
```

To better visualize it, I made the following sketch:

![incorrect_scenario_sample.png](imgs%2Fincorrect_scenario_sample.png)

The arrows represent node X is following node Y (x -> y). **Yellow** nodes are the expected output, while **red** nodes
are the ones that are incorrectly in the output.

While debugging the code after DFS is done, I am getting the following:

```ruby
influencers_reach.sort.map { |key, value| [key, value.size] }

[["user1", 9], ["user10", 9], ["user11", 9], ["user12", 9], ["user13", 9], ["user2", 9], ["user3", 9], ["user4", 9], ["user5", 9], ["user6", 9], ["user7", 9], ["user8", 9]]
```

So every user (except `user_9`) influences `9` users.

After doing a small Desk Check of the algorithm for initial users, I noticed the expected output is correct, and  users
`2, 3, 5, 6` should have "influencers reach" equal to 8 not 9, as shown below.

![desk_check.png](imgs%2Fdesk_check.png)

Checking `influencers_reach` on a `byebug` console, I got:

```ruby
influencers_reach.sort
[["user1", #<Set: {"user11", "user10", "user12", "user3", "user13", "user2", "user5", "user6", "user9"}>],
 ["user10", #<Set: {"user12", "user3", "user13", "user2", "user5", "user6", "user9", "user11", "user10"}>],
 ["user11", #<Set: {"user10", "user12", "user3", "user13", "user2", "user5", "user6", "user9", "user11"}>],
 ["user12", #<Set: {"user3", "user13", "user2", "user5", "user6", "user9", "user12", "user11", "user10"}>],
 ["user13", #<Set: {"user2", "user5", "user3", "user13", "user6", "user9", "user12", "user11", "user10"}>],
 ["user2", #<Set: {"user5", "user3", "user13", "user2", "user6", "user9", "user12", "user11", "user10"}>],
 ["user3", #<Set: {"user13", "user2", "user5", "user3", "user6", "user9", "user12", "user11", "user10"}>],
 ["user4", #<Set: {"user5", "user3", "user13", "user2", "user6", "user9", "user12", "user11", "user10"}>],
 ["user5", #<Set: {"user3", "user13", "user2", "user5", "user6", "user9", "user12", "user11", "user10"}>],
 ["user6", #<Set: {"user9", "user12", "user3", "user13", "user2", "user5", "user6", "user11", "user10"}>],
 ["user7", #<Set: {"user2", "user5", "user3", "user13", "user6", "user9", "user12", "user11", "user10"}>],
 ["user8", #<Set: {"user2", "user5", "user3", "user13", "user6", "user9", "user12", "user11", "user10"}>]]
```

Now, take a closer look to `user10`'s set 🕵... `user10` is included in it's own set 🤦🏽.

```ruby
# old version
influencers_reach[root_user].add(follower)

# new version
influencers_reach[root_user].add(follower) if root_user != follower
```

**After applying the mentioned changes, the score is now 26/26 🎉🏆.**

## Author's considerations
At first glance, the challenge seems easy as it is just a "small" file and implements a method. After reading through
and taking some notes, I noticed that was kind of an iceberg's tip.  The challenge made me rescue my Graphs &
Data Structure chairs of more than 7 years ago during my undergrad times 🥲.

In the end (_it doesn't even matter 🎶_), as can be noticed, I did not create any specs as I usually do because the
given code already works as such. Additionally, I did not move the `find_influencers` method to a class
because I am not allowed to change the code below the marked line. Moving the code to a class could make the code
cleaner and more object-oriented as we could initialize the normalized data in the object, hence, there would be
less need to send `users`, `relationships`, etc as args.

I decided to add some comments to make it easier to understand the code as this kind of algorithm is hard to digest at
first glance. I included Git history of the solution in case you would like to see its evolution.

That's it, folks! Looking forward to e-meeting you! 🤘 

[Algorithms]:https://en.wikipedia.org/wiki/Graph_theory#Algorithms
[DFS]:https://en.wikipedia.org/wiki/Depth-first_search
[GF]:https://en.wikipedia.org/wiki/Graph_theory
[SetGem]:https://github.com/ruby/set