VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # VM de Geração de Dados
  config.vm.define "data_generator" do |data|
    data.vm.synced_folder "data", "/home/vagrant/data"
    data.vm.box = "ubuntu/focal64"
    data.vm.network "private_network", ip: "192.168.56.10"

    # Configurar SSH para o Ansible
    data.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-server python3
    SHELL
  end
end
