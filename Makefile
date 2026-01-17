.PHONY: bench clean

bench-%.txt:
	gleam run -m bench -t $(subst -, ,$*) > $@

bench:
	make -j2 bench-erlang-7.txt bench-javascript-5.txt

# bench-%.txt:
# 	gleam run -m bench $* > $@


# bench-js-%.txt:
# 	gleam run -t javascript -m bench $* > $@


# bench:
# 	make -j2 bench-6.txt bench-js-5.txt

clean:
	gleam clean
	rm -rf bench-*.txt