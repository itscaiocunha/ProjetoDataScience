VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # VM de Geração de Dados
  config.vm.define "data_generator" do |data|
    data.vm.box = "ubuntu/focal64"
    data.vm.network "private_network", ip: "192.168.56.10"
    data.vm.provision "shell", path: "./data_generator/generate_data.sh"
  end

end
