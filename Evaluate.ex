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
    env = EnvTree.add(env, :k, :x)

   #expr = {:div, {:add, {:mul, {:num, :m}, {:num, :m}}, {:mul, {:num, :m}, {:num, :m}}}, {:num, :m}}
   #expr = {:mul, {:div, {:num, :a}, {:add, {:num, :b}, {:num, :c}}}, {:add, {:num, :b}, {:num, :a}}}
   #35 / 5 = 7
   #expr = {:div, {:mul, {:num, :m}, {:num, :u}}, {:num, :m}}
   #3/6 * 7 + x= 7/2 + x
   expr = {:add, {:mul, {:div, {:num, :a}, {:num, :q}}, {:num, :u}}, {:var, :k}}
   #3 + 3/4 = 12/4 + 3/4 = 15/4
   #expr = {:add, {:div, {:num, :a}, {:num, :c}}, {:num, :a}}
   #(3/4)/(2/3) = 9 / 8
   #expr = {:div, {:div, {:num, :a}, {:num, :c}}, {:div, {:num, :b}, {:num, :a}}}
   #a = eval(expr, env)
   #(3*7)+(5*8)+(5/7) = 21 + 40 + 5/7 = 61 + 5/7 = 432/7
#   expr = {:add, {:add, {:mul, {:num, :u}, {:num, :a}}, {:mul, {:num, :m}, {:num, :p}}}, {:div, {:num, :m}, {:num, :u}}}
   #3/2 + 1/3 = 1 / 6
   #expr = {:add, {:div, {:num, :c}, {:num, :b}}, {:div, {:num, :d}, {:num, :a}}}
   #expr = {:add, {:mul, {:num, :a}, {:num, :u}}, {:add, {:num, :d}, {:num, :m}}}
  #IO.write("Original Expression:  #{simplify(expr)}\n")
  #IO.write("Originial with values: #{simplify(EnvTree.lookup(env, expr))}")
  IO.write("Evaluation with substitution: #{simplify(eval(expr, env))}\n")
  #simplify({:add, {:q, {:num, 3}, {:num, 4}}, {:num, 3}})
  #simplify(eval(expr, env))

end

  def simplify({:num, n}) do "#{n}" end
  def simplify({:var, x}) do "#{x}" end
  def simplify({:add, expr1, expr2}) do "(#{simplify(expr1)} + #{simplify(expr2)})" end
  def simplify({:mul, expr1, expr2}) do "#{simplify(expr1)} * #{simplify(expr2)}" end
  def simplify({:q, expr1, expr2}) do "(#{(simplify(expr1))} / #{simplify(expr2)})" end
  def simplify({:q, expr1, expr2}) do "(#{simplify(expr1)} / #{simplify(expr2)})" end
  def simplify(n) do "#{n}" end

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end
  def eval({:var, v}, env) do EnvTree.lookup(env, v) end
  def eval({:add, expr1, expr2}, env) do add(eval(expr1, env), eval(expr2, env)) end
  def eval({:mul, expr1, expr2}, env) do mul(eval(expr1, env), eval(expr2, env)) end
  def eval({:div, expr1, expr2}, env) do divi(eval(expr1, env), eval(expr2, env)) end

#Addition rules
def add({:q, expr1, expr2}, expr3) do divi((expr2*expr3 + expr1), expr2) end
def add(expr3, {:q, expr1, expr2}) do divi(expr2*expr3 + expr1, expr2) end
def add({:q, expr1, expr2}, {:q, expr3, expr2}) do {:q, expr1+expr3, expr3} end
def add(n, p) do n + p end
#def add(expr1, expr2) do {:add, expr1, expr2} end

#Multiplication rules
def mul({:q, expr1, expr2}, {:q, expr3, expr4}) do divi(expr1*expr3, expr2*expr4) end
def mul({:q, expr1, expr2}, expr3) do divi(expr1*expr3, expr2) end
def mul(expr1, expr2) do expr1 * expr2 end
#def mul(expr1, expr2) do {:num, expr1*expr2} end

def divi({:q, expr1, expr2}, {:q, expr3, expr4}) do divi({expr1*expr4}, {expr2*expr3}) end
#if interger division is ok do nom / denom
#else return the rational
def divi(nom,denom) when denom > nom do
  if(rem(denom, nom) == 0) do {:q, trunc(nom/nom), trunc(denom/nom)}
  else {:q, nom, denom} end
end
def divi(nom ,denom) do
  if(rem(nom, denom) == 0) do trunc(nom / denom)
  else {:q, nom, denom} end
end
end
