.PHONY: test

start_dependencies:
	@docker-compose rm -svf
	@docker-compose up -d zookeeper kafka cassandra cassandra-load-keyspace

dry_run:
	mix deps.get
	mix phx.server

run: 
	@docker-compose rm -svf
	@docker-compose up

test:
	@echo "Where are the tests? Soon!!!, keep it calm, I'll fix it"