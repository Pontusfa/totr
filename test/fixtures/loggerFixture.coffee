obj = {}

obj.config = JSON.parse require('fs').readFileSync process.env.configPath

module.exports = obj