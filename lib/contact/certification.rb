class Contact::Certification < Contact::Attribute
  def self.humanize_attributes
    {
      pca: 'PCA',
      cna: 'CNA',
      other_certification: 'RN, LPN, Other',
      no_certification: 'No Certification'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      pca: 'fa-heart-o',
      cna: 'fa-heart',
      other_certification: 'fa-heartbeat',
      no_certification: 'fa-graduation-cap'
    }.with_indifferent_access
  end
end
