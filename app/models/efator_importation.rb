require 'nokogiri'
class EfatorImportation
	def self.import familias, grupos, subgrupos, itens
		xml = Nokogiri::XML(File.open(familias.tempfile))
		import_familias xml

		xml = Nokogiri::XML(File.open(grupos.tempfile))
		import_grupos xml

		xml = Nokogiri::XML(File.open(subgrupos.tempfile))
		import_subgrupos xml

    import_itens itens

    return true
	end

  def self.import_itens itens
    xml = Nokogiri::XML(File.open(itens.tempfile))

    xml.xpath("itens/item").each do |i|

      # load or create the item
      item = Product.where(alternative_id: i['id']).first_or_create

      # get grupo, subgrupo and familia
      grupo = i.xpath("grupo").text
      familia = i.xpath("familia").text
      subgrupo = i.xpath("subgrupo").text

      # update item values
      item.name   = i.xpath("descricao").text
      item.category_id = Category.where(alternative_id: subgrupo, level: 2).first.try(:id)
      item.price  = i.xpath("precovenda").text
      item.active = i.xpath("ativo").text

      item.save

      # method to reorganize the categories tree
      # ps: item id is sent in case of new subgrupo association
      organize_categories(grupo, familia, subgrupo, item.id) unless item.category_id.blank?
    end
	end

	def self.import_familias file
		file.xpath("familias/familia").each do |item|
			Category.create(alternative_id: item['id'],
        							name: item.xpath("descricao").text,
                      level: 0)
		end
	end

	def self.import_grupos file
		file.xpath("grupos/grupo").each do |item|
			Category.create(alternative_id: item['id'],
        							name: item.xpath("descricao").text,
                      level: 1,
                      # if there is a family association set it up
        							parent_id: Category.where(level: 0, alternative_id: item.xpath("familia").text).first.try(:id))
		end
	end

	def self.import_subgrupos file
		file.xpath("subgrupos/subgrupo").each do |item|
			Category.create(alternative_id: item['id'],
							        name: item.xpath("descricao").text,
                      level: 2)
                      # default as OUTROS associated
                      # parent_id: Category.where(level: 1, name: "OUTROS").first.id
		end
	end

  def self.organize_categories grupo_id, familia_id, subgrupo_id, item_id
		familia  = Category.where(alternative_id: familia_id,  level: 0).first
    grupo    = Category.where(alternative_id: grupo_id,    level: 1).first
    subgrupo = Category.where(alternative_id: subgrupo_id, level: 2).first

    # in case grupo already has parent in database
    # and it is not the parent from archive
		if !grupo.parent_id.blank?
      if grupo.parent_id != familia.id
        # do nothing;
        # raise "grupo: #{grupo.name}<br>parent: #{grupo.parent.name} parent_sys_id: #{grupo.parent.alternative_id}"
      end
		else
      # if it has not just set it up
			grupo.update_attributes(parent_id: familia.try(:id))
		end

    # same logic on subgrupos
		if !subgrupo.parent_id.blank?
      if subgrupo.parent_id != grupo.id
        new_subgrupo = Category.where( level: 2,
                                       name: subgrupo.name,
                                       alternative_id: subgrupo.alternative_id,
                                       parent_id: grupo.id ).first_or_create

        # reset the item association
        item = Product.where(id: item_id).first
        item.update_attributes(category_id: new_subgrupo.id)
      end
		else
			subgrupo.update_attributes(parent_id: grupo.id)
		end
	end
end
