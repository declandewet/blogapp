mongoose = require 'mongoose'
moment = require 'moment'

articleSchema = new mongoose.Schema
	title: type: String, unique: true
	body: String
	author: String
	createdAt: type: Date, default: Date.now
	url: type: String, unique: true

articleSchema.virtual('timeAgo').get(-> moment(@createdAt).fromNow())
articleSchema.virtual('formattedDate').get(->moment(@createdAt).format('MMMM Do YYYY'))

module.exports = mongoose.model 'Article', articleSchema