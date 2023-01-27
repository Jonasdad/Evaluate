defmodule EnvTree do

 # @type leaf :: {:leaf, value}
  #@type left | right :: {:node, value, {:leaf, value}, {:leaf, value}} | {:node, value, {:node, value}, {:node, value}}
  #@type tree :: {:node, a, {:leaf, b}, {:leaf, c}}

  def test() do

    test_tree = EnvTree.new()
    test_tree = add(nil, :b, 4)
    test_tree = EnvTree.add(test_tree, :a, 5)
    test_tree = EnvTree.add(test_tree, :c, 2)
    test_tree = EnvTree.add(test_tree, :a, 3)
    test_tree = EnvTree.remove(test_tree, :a)
    #lookup(test_tree, :c)
    #test_tree = EnvTree.add(test_tree, :d, 6)
    #test_tree = EnvTree.add(test_tree, :e, 7)


  end
  #create new empty tree
  def new() do {:node, :nil, :nil, :nil, :nil} end

  #adding a key-value pair to an empty tree ..
  def add(:nil, key, value) do {:node, key, value, :nil, :nil} end

  #the key is found we replace it ..
  def add({:node, key, _, left, right}, key, value) do {:node, key, value, left, right}end

  #return a tree that looks like the one we have
  #but where the left branch has been updated ...
  def add({:node, k, v, left, right}, key, value) when key < k do {:node, k, v, add(left, key, value), right} end
  #same thing but instead update the right banch
  def add({:node, k, v, left, right}, key, value) do {:node, k,v,left,add(right,key,value)} end

  #Element not found and cannot be found
  def lookup({:nil, k, _}, key) do nil end
  def lookup({:node, key, value, _, _}, key) do value end
  def lookup({:node, k, _, left, _}, key) when key < k do lookup(left, key) end
  def lookup({:node, k, _, _, right}, key) do lookup(right, key) end

  #Element not found and cannot be removed
  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do {key, value, remainder} = leftmost(right); {:node, key, value, left, remainder} end

  def remove({:node, k, v, left, right}, key) when key < k do {:node, k, v, remove(left, key), right} end
  def remove({:node, k, v, left, right}, key) do {:node, k, v, left, remove(right, key)} end

  def leftmost({:node, key, value, nil, rest}) do rest end
  def leftmost({:node, k, v, left, right}) do {:node, k, v} = leftmost(left) end
end
