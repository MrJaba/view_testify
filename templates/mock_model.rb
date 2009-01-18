class MockModel
  
  def method_missing( method, *args, &block )
    return nil    
  end
  
end