[ "layer_masher/version",
  "thor",
  "rainbow",
  "rainbow/ext/string"
].map {|gem| require gem }

module LayerMasher
  class CLI < Thor
    desc "smash", "Mash Layer Cake into FISH Environment Variables"
    def smash
      require"pry";binding.pry
    end

    desc "transmute", "Trasmute BASH `export`s to FISH `set -gx`"
    def transmute
    end

    private

    desc "load file", "Load Layer Cake file for transmutation"
    def load_layer_cake
      #layer_cake = []
      #File.foreach "layer_cake.sh" {}
    end

  end
end
