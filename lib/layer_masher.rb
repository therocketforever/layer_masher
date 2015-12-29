[ "layer_masher/version",
  "layer_masher/initialize"
].map {|gem| require gem }

ReportPrefix = Rainbow('Converting BASH Envirioment Variables from ').green
ReportSuffix = Rainbow(' to FISH...').green

LoadFileReportPrefix = Rainbow('Loaded ').green
LoadFileReportSuffix = Rainbow(' Enviroment Variables...').green

TransmuteReportPrefix = Rainbow('Transforming ').blue
TransmuteReportSuffix = Rainbow(' Environment Variables...').blue

WriteReportPrefix = Rainbow('Writing ').cyan
WriteReportSuffix = Rainbow(' Environment Variables to ').cyan

Log = Logger.new(STDOUT)
Log.datetime_format = '%Y-%m-%d %H:%M:%S '
Log.formatter = proc {| severity, datetime, progname, msg | "#{severity}: #{datetime}: #{msg}\n" }

module LayerMasher
  class CLI < Thor
    desc "smash", "Mash Layer Cake into FISH Environment Variables"
    def smash target
      Log.info { ReportPrefix + Rainbow(target).white + ReportSuffix }
      write_layer_cake { transmute { load_layer_cake { target } } }
    end

    private

    desc "transmute", "Trasmute BASH `export`s to FISH `set -gx`"
    def transmute
      raise ArgumentError, "You must provide Layer Cake Array as a block" unless block_given?
      payload = yield
      Log.info { TransmuteReportPrefix + Rainbow(payload.count).magenta + TransmuteReportSuffix }
      payload.each_with_index do |item, index|
        item.gsub!(/export/, "set -gx")
        item.gsub!(/=/, ' ')
        item.gsub!(/(?<!\S)\W(?!\S).*/, '')
        payload[index] = item
      end
    end

    desc "load file", "Load Layer Cake file for transmutation"
    def load_layer_cake
      raise ArgumentError, "You must provide a target path as a block" unless block_given?
      @layer_cake = []
      File.foreach(yield.to_s) {|l| @layer_cake << l}
      Log.info { LoadFileReportPrefix + Rainbow(@layer_cake.count).magenta + LoadFileReportSuffix }
      @layer_cake
    end

    desc "write file", "Write transformed Layer Cake to File"
    def write_layer_cake
      payload = yield
      Log.info { WriteReportPrefix + Rainbow(payload.count).white + WriteReportSuffix }
      Log.info { Rainbow('SUCCESS!!').green if File.write "layer_cake.fish", payload.join }
    end

  end
end
