define ['lodash'], (_) ->
  class IndexedCollection
    constructor: (elements = []) ->
      @collection = Array.prototype.concat elements
      @_idx = {}
      @rebuildIndex()

    rebuildIndex: ()->
      @_idx = _.reduce @collection, (idx, item, collection_inex)->
        idx[item.id] = collection_inex
        idx
      , {}

    extend: (itemOrList, sort = false)->
      for item in Array.prototype.concat itemOrList
        if item.id not in @_idx
          @collection.push item
      if sort
        @collection = _.sortBy 'id'
      @rebuildIndex()

    update: (itemOrList) ->
      for item in Array.prototype.concat itemOrList
        itemIndex = @_idx[item.id]
        if itemIndex?
          _.extend @collection[itemIndex], item

    remove: (itemOrList) ->
      idsToRemove = _.pluck Array.prototype.concat(itemOrList), 'id'
      _.remove @collection, (item)->
        item.id in idsToRemove
      @rebuildIndex