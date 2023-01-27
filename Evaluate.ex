#(2x + 3) + 1/2
#{:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}

defmodule Evaluate do
  @type literal() :: {:num, number()}
  @type expr() :: {:add, expr(), expr()}
                | {:sub, expr(), expr()}
                | {:mul, expr(), expr()}
                | {:div, expr(), expr()}
                | literal()

  def test() do
    env = EnvTree.new()
    env = EnvTree.add(:nil, :a, 3)
    env = EnvTree.add(env, :c, 4)
    env = EnvTree.add(env, :d, 1)
    env = EnvTree.add(env, :e, 2)
    expr = {:add, {:num, :c}, {:num, :b}}

  eval(expr, env)
  end

  #Create an environment (tree or linked list) with an atom as :var and value as :num
  #use eval to create simplifed expressions - Each atom will have an assigned value to it.

  #maybe use linked list as its easier - BST would case all kinds of havoc(?)

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end

  def eval({:var, v}, env) do EnvTree.lookup(env, v) end

  def eval({:add, expr1, expr2}, env) do
    add(EnvTree.lookup(env, expr1), EnvTree.lookup(env, expr2))
  end
#  def eval({:mul, expr, expr}, env) do end

#  def eval({:div, expr, expr}, env) do end

  def add(expr1, expr2) do expr1 + expr2 end
#  def mul(expr, expr) do end
#  def div(expr, expr) do end
end
