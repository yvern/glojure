.PHONY: bench clean

bench-%.txt:
	gleam run -t $(subst -, ,$*) > $@

bench:
	make -j2 bench-erlang-7.txt bench-javascript-5.txt

clean:
	gleam clean
	rm -rf bench-*.txt