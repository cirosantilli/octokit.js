define = window?.define or (name, deps, cb) -> cb (require(dep.replace('cs!octokit-part/', './')) for dep in deps)...
define 'octokit', [
  'cs!octokit-part/batcher'
  'cs!octokit-part/replacer'
  'cs!octokit-part/request'
  'cs!octokit-part/helper-promise'
], (Batcher, Replacer, Request, {newPromise, allPromises}) ->

  # Combine all the classes into one client

  Octokit = (clientOptions={}) ->

    # For each request, convert the JSON into Objects
    _request = Request(clientOptions)

    request = (method, path, data, options={raw:false, isBase64:false, isBoolean:false}) ->
      replacer = new Replacer(request)

      data = replacer.dasherize(data) if data

      return _request(method, path, data, options)
      .then (val) ->
        return val if options.raw
        obj = replacer.replace(val)
        Batcher(request, obj.url, obj)
        return obj

    path = ''
    obj = {}
    Batcher(request, path, obj)

    # Special case for `me`
    obj.__defineGetter__ 'me', () ->
      return Batcher(request, "#{path}/user")

    return obj


  module?.exports = Octokit
  window?.Octokit = Octokit
  return Octokit
