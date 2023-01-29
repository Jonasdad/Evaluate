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
    env = EnvTree.add(env, :p, 12)
    env = EnvTree.add(env, :u, 7)
    #expr = {:mul, {:div, {:add, {:add, {:num, :a}, {:num, :b}}, {:add, {:num, :c}, {:num, :d}}}, {:num, :c}}, {:num, :b}}
    #a/(d+c) * (m+a) = (3/5) * (8) = 24/5
    #(3)/(6) * 5 = 15 / 6
    #((5*7) + (3*12)) / 4 = (35) + 36 / 4 = 71 / 4

        #rad 22 fungerar utan rad 71
   # expr = {:div, {:add, {:mul, {:num, :m}, {:num, :m}}, {:mul, {:num, :m}, {:num, :m}}}, {:num, :m}}
        #rad 23 fungerar med rad 71
   expr = {:mul, {:div, {:num, :a}, {:add, {:num, :b}, {:num, :c}}}, {:add, {:num, :b}, {:num, :a}}}
   # expr = {:mul, {:mul, {:add, {:num, :a}, {:num, :b}}, {:num, :m}}, {:num, :b}}
   #expr = {:add, {:num, :a}, {:num, :m}}
  # expr = {:mul, {:div, {:num, :a}, {:num, :b}}, {:num, :a}}
   IO.write("Original Expression:  #{Evaluate.simplify(expr)}\n")
#   IO.write("Expression with substitution #{Evaluate.simplify(EnvTree.lookup(env, expr))}\n")
   IO.write("Evaluation with substitution:  #{(Evaluate.eval(expr, env))}\n")
   #eval(expr, env)
  end


  def simplify({:num, n}) do "#{n}" end
  def simplify({:add, expr1, expr2}) do "(#{simplify(expr1)} + #{simplify(expr2)})" end
  def simplify({:mul, expr1, expr2}) do "#{simplify(expr1)} * #{simplify(expr2)}" end
  def simplify({:div, expr1, expr2}) do "(#{simplify(expr1)} / #{simplify(expr2)})" end
  def simplify({:q, expr1, expr2}) do "(#{simplify(expr1)} / #{simplify(expr2)}" end
   #Create an environment (tree or linked list) with an atom as :var and value as :num
  #use eval to evaluate expressions - Each atom will have an assigned value to it.

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end

  def eval({:var, v}, env) do EnvTree.lookup(env, v) end

  def eval({:add, expr1, expr2}, env) do
    add(eval(expr1, env), eval(expr2, env))
  end
  def eval({:mul, expr1, expr2}, env) do
    #if(expr1 = {:div, nom, denom}) do
     # Evaluate.div(mul(eval(nom, env), eval(expr2, env)), eval(denom, env))
    #end
    mul(eval(expr1, env), eval(expr2, env))
  end

  def eval({:div, expr1, expr2}, env) do
    if(rem(eval(expr1, env), eval(expr2, env)) == 0) do
      trunc(Evaluate.div(eval(expr1, env), eval(expr2, env)))
  #  else "#{eval(expr1, env)} / #{eval(expr2, env)}"
      else {:div, eval(expr1, env), eval(expr2, env)}
      end
    end

 # def eval({:mul, {:q, expr1, expr2}, expr3}) do Evaulate.div(mul(expr1, expr3), expr2) end
# test 123

 def add(expr1, expr2) do expr1 + expr2 end
 def mul({type, n, d}, expr1) when type == :div do Evaluate.div({:num, n*expr1}, {:num, d}) end
 def mul(expr1, expr2) do expr1 * expr2 end

 def div({:num, nom}, {:num, denom}) do
  if(rem(nom, denom) == 0) do
    trunc(nom / denom)
  else "#{nom} / #{denom}"
    end
   end
 def div(expr1, expr2) do expr1 / expr2 end
end
