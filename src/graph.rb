# frozen_string_literal: true

module Graph
  extend self

  # procedure DFS(G, v) is
  #     label v as discovered
  #     for all directed edges from v to w that are in G.adjacentEdges(v) do
  #         if vertex w is not labeled as discovered then
  #             recursively call DFS(G, w)
  def deep_first_search(root_user, user, nodes, discovered_nodes, influencers_count)
    followers = nodes[user]

    return if followers.nil?

    followers.each_with_index do |follower, index|
      next if discovered_nodes[user][index]

      discovered_nodes[user][index] = true
      influencers_count[root_user]  += 1
      deep_first_search(root_user, follower, nodes, discovered_nodes, influencers_count)
    end
  end
end