require 'travis/ajax'
require 'models'

@Travis.RestAdapter = DS.RESTAdapter.extend Travis.Ajax,
  mappings:
    repositories: Travis.Repository
    repository:   Travis.Repository
    builds:       Travis.Build
    build:        Travis.Build
    commits:      Travis.Commit
    commit:       Travis.Commit
    jobs:         Travis.Job
    job:          Travis.Job
    account:      Travis.Account
    accounts:     Travis.Account
    worker:       Travis.Worker
    workers:      Travis.Worker

  plurals:
    repository: 'repositories',
    build: 'builds'
    branch: 'branches'
    job: 'jobs'
    worker: 'workers'
    profile: 'profile'


  findQuery: (store, type, query, recordArray) ->
    root   = @rootForType(type)
    plural = @pluralize(root)

    @ajax(@buildURL(root, null, query), "GET", {
      data: query,
      success: (json) ->
        @sideload(store, type, json, plural)
        recordArray.load(json[plural])
    })

  buildURL: (record, suffix, query) ->
    url = @_super.apply this, arguments
    if query && query.repository_id
      url = "/repositories/#{query.repository_id}#{url}"
      delete query.repository_id

    console.log url
    url
