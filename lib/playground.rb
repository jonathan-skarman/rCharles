def arrToLength2(arr)
	if arr.length > 2
			temp_arr = [arr[0], []]

			i = 1
			while i < arr.length
					temp_arr[1].append(arr[i])
					i += 1
   end
			arr = temp_arr
   end

  arr
end
