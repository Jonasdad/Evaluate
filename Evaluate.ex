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

   #expr = {:div, {:add, {:mul, {:num, :m}, {:num, :m}}, {:mul, {:num, :m}, {:num, :m}}}, {:num, :m}}
   #expr = {:mul, {:div, {:num, :a}, {:add, {:num, :b}, {:num, :c}}}, {:add, {:num, :b}, {:num, :a}}}
   #35 / 3
   #expr = {:div, {:mul, {:num, :m}, {:num, :u}}, {:num, :a}}
   #3/12 * 7 = 7/4
   expr = {:mul, {:div, {:num, :a}, {:num, :p}}, {:num, :u}}
   IO.write("Original Expression:  #{Evaluate.simplify(expr)}\n")
   IO.write("Evaluation with substitution:  #{(Evaluate.eval(expr, env))}\n")
  end


  def simplify({:num, n}) do "#{n}" end
  def simplify({:add, expr1, expr2}) do "(#{simplify(expr1)} + #{simplify(expr2)})" end
  def simplify({:mul, expr1, expr2}) do "#{simplify(expr1)} * #{simplify(expr2)}" end
  def simplify({:div, expr1, expr2}) do "(#{simplify(expr1)} / #{simplify(expr2)})" end

  def eval({:num, n}, env) do EnvTree.lookup(env, n) end

  def eval({:var, v}, env) do EnvTree.lookup(env, v) end

  def eval({:add, expr1, expr2}, env) do
    add(eval(expr1, env), eval(expr2, env))
  end

  def eval({:mul, expr1, expr2}, env) do
    mul(eval(expr1, env), eval(expr2, env))
  end

  #Special case when demoninator is larger AND a factor of nominator
  def eval({:div, expr1, expr2}, env) when expr2 > expr1 do
    if(rem(eval(expr2, env), eval(expr1, env)) == 0) do
        ({:div, 1, trunc(eval(expr2, env)/eval(expr1, env))})
      else divi(eval(expr1,env), eval(expr2, env))
    end
  end

  def eval({:div, expr1, expr2}, env) do
    divi(eval(expr1, env), eval(expr2, env))
    end


  # def eval({:mul, {:q, expr1, expr2}, expr3}) do Evaulate.div(mul(expr1, expr3), expr2) end
  # test 123

 def add(expr1, expr2) do expr1 + expr2 end
 #Special case multiplication of rational number and integer: a/b * c return a*c / b and simplify
 def mul({:div, expr1, expr2}, expr3) do divi(expr1*expr3, expr2) end
 def mul(expr1, expr2) do expr1 * expr2 end
 #if interger division is ok do nom / denom
 #else return the rational
 def divi(nom, denom) do
  if(rem(nom, denom) == 0) do
    trunc(nom / denom)
  else
    "#{nom} / #{denom}"   end
   end

end
