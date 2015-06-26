define 'assets/scripts/utils/indexed_collection.js', ['lodash'], (_) ->
  class IndexedCollection
    constructor: (elements = []) ->
      @collection = Array.prototype.concat elements
      @_idx = {}
      @rebuildIndex()

    rebuildIndex: ()=>
      @_idx = _.reduce @collection, (idx, item, collection_inex)->
        idx[item.id] = collection_inex
        idx
      , {}

    extend: (itemOrList)=>
      for item in Array.prototype.concat itemOrList
        if not @_idx[item.id]?
          @collection.push item
      @rebuildIndex()

    update: (itemOrList)=>
      for item in Array.prototype.concat itemOrList
        itemIndex = @_idx[item.id]
        if itemIndex?
          _.extend @collection[itemIndex], item

    remove: (itemOrList)=>
      idsToRemove = _.pluck Array.prototype.concat(itemOrList), 'id'
      _.remove @collection, (item)->
        item.id in idsToRemove
      @rebuildIndex

    get: (id)=>
      index = @_idx[id]
      if index? then @collection[index] else null

    removeById: (id)=>
      index = @_idx[id]
      if index?
        @collection.splice index, 1
        @rebuildIndex