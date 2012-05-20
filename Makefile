EBIN_DIR=ebin
ERLC=erlc -W0
ERL=erl -noshell -pa $(EBIN_DIR)

.PHONY: compile test clean

compile: $(EBIN_DIR)

$(EBIN_DIR): $(shell find lib -type f -name "*.ex")
	@ rm -rf ebin
	@ echo Compiling ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	elixirc lib -o ebin
	@ echo


test: compile
	@ echo Running tests ...
	time elixir -pa ebin -r "test/test_helper.exs" -pr "test/*_test.exs"
	@ echo
clean:
	rm -rf $(EBIN_DIR)
	@ echo
