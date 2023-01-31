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
    env = EnvTree.add(env, :b, 2)
    env = EnvTree.add(env, :m, 5)
    env = EnvTree.add(env, :p, 8)
    env = EnvTree.add(env, :u, 7)
    env = EnvTree.add(env, :q, 6)
    env = EnvTree.add(env, :k, 9)

  #(8 + 3/2) *(2) + 2 / 4 = 20/4 = 5
    #expr = {:div, {:add, {:mul, {:add, {:num, :p},  {:div, {:num, :a}, {:num, :b}}}, {:num, :b}}, {:num, :d}}, {:num, :c}}
  #2 - 3/2 = 4/2 - 3/2 = 1/2
  #expr = {:sub, {:num, :b}, {:div, {:num, :a}, {:num, :b}}}
  #expr = {:mul, {:div, {:num, :d}, {:num, :c}}, {:div, {:num, :a}, {:num, :b}}}
  expr = {:div, {:q, {:num, :a}, {:num, :b}}, {:q, {:num, :c}, {:num, :m}}}
  IO.write("Evaluation with substitution: #{simplify(eval(expr, env))}\n")
end

  def simplify({:num, n}) do "#{n}" end
  def simplify({:var, x}) do "#{x}" end
  def simplify({:add, expr1, expr2}) do "(#{simplify(expr1)} + #{simplify(expr2)})" end
  def simplify({:mul, expr1, expr2}) do "#{simplify(expr1)} * #{simplify(expr2)}" end
  def simplify({:q, expr1, expr2}) do "(#{(simplify(expr1))} / #{simplify(expr2)})" end
  def simplify({:div, expr1, expr2}) do "(#{simplify(expr1)} / #{simplify(expr2)})" end
  def simplify(n) do "#{n}" end

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end
  def eval({:var, v}, env) do EnvTree.lookup(env, v) end
  def eval({:add, expr1, expr2}, env) do add(eval(expr1, env), eval(expr2, env)) end
  def eval({:sub, expr1, expr2}, env) do sub(eval(expr1, env), eval(expr2, env)) end
  def eval({:mul, expr1, expr2}, env) do mul(eval(expr1, env), eval(expr2, env)) end
  def eval({:q, expr1, expr2}, env) do divi(eval(expr1, env), eval(expr2, env)) end
  def eval({:div, expr1, expr2}, env) do divi(eval(expr1, env), eval(expr2, env)) end

#Addition rules
def add({:q, expr1, expr2}, {:q, expr3, expr2}) do divi(expr1+expr3, expr2) end
  def add({:q, expr1, expr2}, expr3) do divi((expr2*expr3 + expr1), expr2) end
  def add(expr3, {:q, expr1, expr2}) do divi(expr2*expr3 + expr1, expr2) end
  def add(n, p) do n + p end

#Subtraction rules (minus addition)
#3/4 - 2 = 3/4 - 8/4 = -5/4
def sub({:q, expr1, expr2}, {:q, expr3, expr2}) do divi(expr1-expr3, expr2) end
def sub({:q, expr1, expr2}, expr3) do divi((-(expr2*expr3) + expr1), expr2) end
def sub(expr3, {:q, expr1, expr2}) do divi((-(expr2*expr3) + expr1), expr2) end
def sub(p,q) do p-q end

#Multiplication rules
  def mul({:q, expr1, expr2}, {:q, expr3, expr4}) do divi(expr1*expr3, expr2*expr4) end
  def mul({:q, expr1, expr2}, expr3) do divi(expr1*expr3, expr2) end
  def mul(expr3, {:q, expr1, expr2}) do divi(expr1*expr3, expr2) end
  def mul(expr1, expr2) do expr1 * expr2 end

  def divi({:q, expr1, expr2}, {:q, expr3, expr4}) do divi(expr1*expr4, expr2*expr3) end
  def divi(nom,denom) when denom > nom do
    if(rem(denom, nom) == 0) do {:q, trunc(nom/nom), trunc(denom/nom)}
    else
      c = gd(nom, denom)
      {:q, trunc(nom/c), trunc(denom/c)} end
  end
  def divi(nom ,denom) do
    if(rem(nom, denom) == 0) do trunc(nom / denom)
    else
      c = gd(nom, denom)
      {:q, trunc(nom/c), trunc(denom/c)} end
  end
#Find greatest divisor - e.g., gd(6,4) = 2
  def gd(p, 0) do p end
  def gd(p, q) do gd(q, rem(p, q)) end


end
