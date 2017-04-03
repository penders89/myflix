Fabricator(:queue_item) do
  user
  video
  ranking { [1,2,3].sample }
end