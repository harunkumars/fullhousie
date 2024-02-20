class CardRow < ApplicationRecord
  rich_enum row_type: {
    first_row: [1, (1..3)],
    middle_row: [2, (4..6)],
    last_row: [3, (7..10)]
  }, alt: 'addend_range'

  after_initialize :populate_cells

  private

  def populate_cells
    cells_to_block = (0..8).to_a.sample(4)
    self.cells = Array.new(9) do |i|
      cells_to_block.any?(i) ? block_cell : element_for_cell(i)
    end
  end

  def block_cell
    {
      number: 0,
      status: -1
    }
  end

  def element_for_cell(i)
    {
      number: i * 10 + row_type_addend_range.to_a.sample,
      status: 0
    }
  end
end
