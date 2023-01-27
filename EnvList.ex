defmodule EnvList do

  def test() do
    list = EnvList.new()
    a = EnvList.add(list, :a, 1)
    b = EnvList.add(a, :b, 2)
    c = EnvList.add(b, :c, 3)
    EnvList.lookup(c, :c)
    d = EnvList.remove(c, :a)
    e = EnvList.add(d, :f, 9)
    f = EnvList.add(e, :f, 0)
  end

  #Return empty list
  def new() do [] end
  #Add - 3 cases - Empty, Key found -> update value, Key not found insert
  def add([], key, value) do [{key, value}] end #if list is empty -> do {key, value}
  #If matching keys -> update value
  def add([{key, val}| t], key ,value) do [{key, value} | t] end
  #if(k == key) do [{key, value} | t] end
  #If not matching keys -> append old list onto new list.
  def add([{k, val} | t], key, value) do [{k, val} | add(t, key, value)] end


  def lookup([], _) do nil end #key not present
  def lookup([{key, value} | t ], find_key) do
    if(key == find_key) do
      {key, value} #key found -> return key-value pair
    else
      lookup(t, key) #key not found, keep traversing
    end
  end

  def remove([], _) do [] end
  def remove([{key, value} | t], delete_key) do
    if(key != delete_key) do  #while delete_key != key, create the new list
      [{key, value}] ++ remove(t, delete_key)
    else                      #if key == delete_key, ignore it and continue
      remove(t, delete_key)
    end
  end
end
