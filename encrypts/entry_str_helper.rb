require 'openssl'

module EntryStrHelper 

  def cipher
    OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  end

  def cipher_key
    name = File.read("../a_secrets/secret.json") 
    eval(name)[:name]
  end

  def file_content
    unless File.exists?("../caches/code.md")
      File.open("../caches/code.md", "w+") do |f|
        f.puts ""
      end
    end
    File.read("../caches/code.md")
  end

end