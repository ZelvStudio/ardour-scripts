ardour {
	["type"]    = "EditorAction",
	name        = "Rename regions to prime numbers",
	license     = "MIT",
	author      = "Zelv",
	description = [[Rename the selected regions to prime numbers by order of position on the timeline]]
}


function factory () return function ()

------------------------
-- preliminary functions
------------------------
function sieve_of_eratosthenes(n)
	local is_prime = {}
	for i = 1, n do
		is_prime[i] = 1 ~= i
	end

	for i = 2, math.floor(math.sqrt(n)) do
		if is_prime[i] then
			for j = i*i, n, i do
				is_prime[j] = false
			end
		end
	end

	return is_prime
end

-- not optimized, computes too many primes for large numbers
function get_primes(n)
	local is_prime = sieve_of_eratosthenes( (n+1)*n )
	local primes = {}
	for i, value in pairs(is_prime) do
		if value then
			table.insert(primes, i)
		end
	end
	return primes
end

------------------------
-- script start
------------------------
	-- get Editor GUI Selection
	local selection = Editor:get_selection ()

	-- save list of selected regions
	local regions_to_rename = {}

	for r in selection.regions:regionlist ():iter () do
		table.insert(regions_to_rename, r)
	end

	-- sort regions by timeline position
	table.sort(regions_to_rename, function(a,b)
		return a:position() < b:position()
	end)
	
	-- build list of prime numbers
	local primes = get_primes(#regions_to_rename)

	for i, r in pairs(regions_to_rename) do
		print(r:name (), '->', primes[i])
		r:set_name(tostring(primes[i]))
	end
	
end end

