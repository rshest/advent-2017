function solution(path)
  offsets = textread(path, '%d' ,'delimiter' , ',');

  fid = fopen (path);
  seed = fgetl(fid);

  res = transform(0:255,  transpose(offsets));
  printf("Part 1: %d\n", res(1)*res(2));
  printf("Part 2: %s\n", knothash(seed));
end


function res = knothash(seed)
  codes =  horzcat(toascii(seed), [17 31 73 47 23]);
  codes = transform(0:255, codes, 64);
  res = tolower(densify(codes));
end


function nums = rev(nums, pos, count)
  n = length(nums);
  if count > 0
    for i = 0:idivide(count, 2) - 1
      p1 = mod(pos + i, n) + 1;
      p2 = mod(pos + count - i - 1, n) + 1;
      tmp = nums(p1);
      nums(p1) = nums(p2);
      nums(p2) = tmp;
    end
  end
end


function nums = transform(nums, offsets, times)
  if nargin < 3
    times = 1;
  end

  n = length(nums);
  
  pos = 0;
  skip = 0;

  for i = 1:times
    for len = offsets
      nums = rev(nums, pos, len);
      pos = mod(pos + len + skip, n);
      skip += 1;
    end
  end
end


function dh = densify(codes)
  dh = '';
  n = length(codes);
  for i = 0:16:(n - 1)
    res = 0;
    for j = i:i + 15
      res = bitxor(res, codes(j + 1));
    end
    dh = [dh dec2hex(res, 2)]; 
  end
end


solution("input.txt");
