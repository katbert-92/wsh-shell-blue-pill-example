import time

def idiv(a, b)
    return int(a / b)
end

def pi_digits(n)
    var arr = []
    var len = int(10 * n / 3)
    for i : 0..(len - 1)
        arr.push(2)
    end
    var pi = ""
    var carry = 0

    for i : 0..(n-1)
        var sum = 0
        var j = len - 1
        while j > 0
            var x = arr[j] * 10 + sum
            arr[j] = x % (2*j + 1)
            sum = idiv(x, 2*j + 1) * j
            j = j - 1
        end
        var x = arr[0] * 10 + sum
        arr[0] = x % 10
        var digit = idiv(x, 10)
        if i == 0
            pi = pi .. str(digit) .. "."
        else
            pi = pi .. str(digit)
        end
    end
    return pi
end

var t1 = time.clock()
print("PI:", pi_digits(1000))
print("dT:", time.clock() - t1)

