
node.reverse_merge!({
  rbenv: {
    global: '2.4.3',
    versions: %w[
      2.4.3
    ],
  },
  'rbenv-default-gems' => {
    'default-gems' => %w[ bundler ]
  }
})

include_recipe 'rbenv::system'
