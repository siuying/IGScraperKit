class ScraperScope < BasicObject
  attr_reader :node, :url

  def initialize(node, url)
    @node = XMLNode.new(node)
    @url = url
  end

  def self.builder(doc, url, script)
    scope = self.new(doc, url)
    block = eval("lambda { #{script} }")
    scope.instance_eval(&block)
  end
end