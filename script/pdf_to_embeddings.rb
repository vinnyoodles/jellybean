require 'csv'
require 'optparse'
require 'openai'
require 'pdf-reader'

OPENAI_EMBEDDINGS_MODEL = "text-embedding-ada-002"

args = {}
OptionParser.new do |opt|
  opt.on('--pdf PDF') { |o| args[:pdf] = o }
end.parse!

unless args.key?(:pdf)
    puts("Must pass in a pdf file")
    return
end

client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
reader = PDF::Reader.new(args[:pdf])

CSV.open('embeddings.csv', 'w') do |csv|
    csv << ['page_number', 'text', 'embedding', 'tokens']
    reader.pages.each_with_index do |page, i|

        input = page.text.gsub("\n", '').squeeze(' ')
        if input.length == 0
            next
        end
        puts("Processing page #{i}")
        sleep(1)

        response = client.embeddings(
            parameters: {
                model: OPENAI_EMBEDDINGS_MODEL,
                input: page.text.gsub('\n', '').squeeze(' ')
            }
        )
        embedding = response['data'][0]['embedding']
        tokens = response['usage']['total_tokens']
        csv << [i, input, embedding, tokens]
    end
end
