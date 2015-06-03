JournalApp.Views.PostsIndex = Backbone.View.extend({
  template: JST['posts_index'],


  initialize: function (option) {
    this.$el = option.$el;
    this.listenTo(this.collection, "remove reset", this.render);
  },

  render: function () {
    console.log('rendering');
    this.$el.html(this.template({collection: this.collection}));
    var container = this.$el.find('ul');
    this.collection.each(function(post) {
      var postView = new JournalApp.Views.PostsIndexItem({model: post});
      container.append(postView.render().$el);
    });
    return this;
  }
});
