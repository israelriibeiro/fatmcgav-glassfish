$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","..",".."))
require 'puppet/provider/asadmin'

Puppet::Type.type(:jmsdest).provide(:asadmin, :parent =>
Puppet::Provider::Asadmin) do
  desc "Glassfish JMS physical destination support."
  def create
    args = Array.new
    args << 'create-jmsdest'
    args << "--target" << @resource[:target] if @resource[:target]
    args << '--desttype' << @resource[:desttype]
    if hasProperties? @resource[:properties]
      args << '--property'
      args << "\'#{prepareProperties @resource[:properties]}\'"
    end
    args << @resource[:name]

    asadmin_exec(args)
  end

  def destroy
    args = Array.new
    args << 'delete-jmsdest'
    args << 'target' << @resource[:target] if @resource[:target]
    args << @resource[:name]

    asadmin_exec(args)
  end

  def exists?
    args = Array.new
    args << "list-jmsdest"
    args << @resource[:target] if @resource[:target]

    asadmin_exec(args).each do |line|
      return true if @resource[:name] == line.chomp
    end
    return false
  end
end
