class AppBlog
	def initialize(blog)
		if !blog.is_a? Blog
			raise "'blog' must be a Blog obj"
		end

		@model = blog
	end

	def sync_articles

	end

	def articles_synced

	end
end