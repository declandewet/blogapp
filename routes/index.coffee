Article = require '../models/article'

exports.home = (req, res) ->
	Article.count (err, count) ->
		if err then res.send err
		else if count is 0 then res.send "No blog posts to display."
		else
			Article.findOne({}).sort('-createdAt').exec 'findOne', (err, article) ->
				if err then res.send err
				else res.redirect article.url

exports.page = (req, res) ->
	pagenumber = req.params.number
	skip = 10 * (pagenumber - 1)
	Article.find({}).sort('-createdAt').skip(skip).limit(10).exec 'find', (err, articles) ->
		if err then res.send err else
			res.render 'page'
				title: "page #{pagenumber}"
				articles: article for article in articles

exports.new = (req, res) ->
	res.render 'new',
		title: 'New Article'

exports.article = (req, res) ->
	Article.findOne ({url: req.params.url}), (err, article) ->
		if err then res.send err else
			res.render 'article',
					title: article.title
					author: article.author
					date: article.formattedDate
					body: article.body
					url: article.url

exports.newpost = (req, res) ->
	OPERATOR = /~|`|\!|@|#|\$|%|\^|&|\*|\(|\)|-|_|\+|\=|\{|\[|\}|\]|\||\\|\:|;|"|'|<|,|>|\.|\?|\/*/ig
	article = new Article
		title: req.body.title
		body: req.body.body
		author: req.body.author
		url: req.body.title
		.replace(OPERATOR, '')
		.replace(/\s+/g, '-')
		.replace(/-*$/, '')
		.replace(/^-*/, '')
		.toLowerCase()
	article.save (err) -> if err then res.send err else res.redirect '/'