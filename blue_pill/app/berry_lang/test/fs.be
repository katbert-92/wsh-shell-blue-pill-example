import os

root_dir = "0:/"

test_dir = root_dir +"berry_fs_test"
if os.path.exists(test_dir) == false
    if os.mkdir(test_dir) == true
		print("Directory created")
	end
else 
	print(f"Directory {test_dir} exists")
end

if os.path.isdir(test_dir) == true
	print(f"{test_dir} is a directory")
end

test_file = root_dir + test_dir + "test.txt"
f = open(test_file, "w+")
f.write("hello, berry!\n12345\nabcde")
f.flush()
print("After writing, position:", f.tell())

f.seek(0)
content = f.read()
print(f"File content:\r\n{content}")

f.seek(0)
print(f"First line: {f.readline()}")
print(f"Next line: {f.readline()}")

f.seek(0)
content = f.readbytes()
print(f"File content (bytes): {content}")

print(f"File size: {f.size()}")

f.close()

if os.path.isfile(test_file) == true
	print(f"{test_file} is a file")
end

print("In test folder:", os.listdir(test_dir))

if os.remove(test_file) == true
	print("File removed")
end

print("In test folder:", os.listdir(test_dir))
print("In root folder:", os.listdir(root_dir))

if os.remove(test_dir) == true
	print("Dir removed")
end

print("In folder:", os.listdir(root_dir))

print("Filesystem tests completed")
