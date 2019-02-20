require 'benchmark'
require 'dry/monads/task'
require './lib/blog/get'

class GetPhotoaAndAlbums
  include Dry::Monads::Task::Mixin

  def call
    # Start two tasks running concurrently
    albums = Task { fetch_albums }
    photos = Task { fetch_photos }

    # Combine two tasks
    albums.bind do |albums_result|
      photos.fmap do |photos_result|
        [albums_result, photos_result]
      end
    end
  end

  def fetch_albums
    Blog::Get.new.call(endpoint: 'albums')
  end

  def fetch_photos
    Blog::Get.new.call(endpoint: 'photos')
  end
end

result = Benchmark.measure do
  albums = Blog::Get.new.call(endpoint: 'albums').value!.map { |a| [a['id'], a] }.to_h
  photos = Blog::Get.new.call(endpoint: 'photos')
  photos.value!.each do |photo|
    # puts "#{albums[photo['albumId']]['title']}: #{photo['url']}"
  end
end
puts result

result = Benchmark.measure do
  albums, photos = GetPhotoaAndAlbums.new.call.value!

  albums = albums.value!.map { |a| [a['id'], a] }.to_h
  photos.value!.each do |photo|
    # puts "#{albums[photo['albumId']]['title']}: #{photo['url']}"
  end
end
puts result
