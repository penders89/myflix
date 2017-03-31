Fabricator(:queue_item) do
  user
  video
  ranking { 1 }
end