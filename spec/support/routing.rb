# http://stackoverflow.com/questions/13262656/rails-3-1-set-host-in-test-environment
class ActionDispatch::Routing::RouteSet
  def url_for_with_host_fix(options)
    url_for_without_host_fix(options.merge(:host => "test.host"))
  end

  alias_method_chain :url_for, :host_fix
end
