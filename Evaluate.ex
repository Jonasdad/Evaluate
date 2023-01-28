#(2x + 3) + 1/2
#{:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}

defmodule Evaluate do
  @type literal() :: {:num, number()}
  @type expr() :: {:add, expr(), expr()}
                | {:sub, expr(), expr()}
                | {:mul, expr(), expr()}
                | {:div, expr(), expr()}
                | literal()

#expr: {:num, :c}
#tree: {:node, :c, 4 }.... etc
  def test() do
    env = EnvTree.new()
    env = EnvTree.add(:nil, :a, 3)
    env = EnvTree.add(env, :c, 4)
    env = EnvTree.add(env, :d, 1)
    env = EnvTree.add(env, :b, 2)
    env = EnvTree.add(env, :m, 5)
 #   expr = {:add, {:add, {:num, :a}, {:num, :b}}, {:add, {:num, :c}, {:num, :d}}}
    expr = {:mul, {:div, {:mul, {:num, :c}, {:num, :d}}, {:add, {:num, :a}, {:num, :b}}}, {:num, :m}}
    eval(expr, env)
  end

  #Create an environment (tree or linked list) with an atom as :var and value as :num
  #use eval to evaluate expressions - Each atom will have an assigned value to it.

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end

  def eval({:var, v}, env) do EnvTree.lookup(env, v) end

  def eval({:add, expr1, expr2}, env) do
    add(eval(expr1, env), eval(expr2, env))
    #    eval(add(EnvTree.lookup(env, expr1), EnvTree.lookup(env, expr2)), env)
  end
  def eval({:mul, expr1, expr2}, env) do
    mul(eval(expr1, env), eval(expr2, env))
  end

  def eval({:div, expr1, expr2}, env) do
    if(rem(eval(expr1, env), eval(expr2, env)) == 0) do
      Evaluate.div(eval(expr1, env), eval(expr2, env))
      eval(Evaluate.div(EnvTree.lookup(env, expr1), EnvTree.lookup(env, expr2)), env)
    else "(#{eval(expr1, env)}/#{eval(expr2, env)})"
    end
  end

  def add(expr1, expr2) do expr1 + expr2 end
  def mul(expr1, expr2) do expr1 * expr2 end
  def div(expr1, expr2) do expr1 / expr2 end
  def div(expr1, 0) do :error end

end
