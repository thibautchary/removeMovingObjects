function image_reference=BestAlignImages(image_reference,image_original,m,log1,log2)
  error=100000;
  for i=1:m
      display(['iteration ',num2str(i)]);
      i1=randi(length(log1));
      i2=randi(length(log1));
      i3=randi(length(log1));
      i4=randi(length(log1));
      log1(:,i1)
      log1(:,i2)
      log1(:,i3)
      log1(:,i4)
      log2(:,i1)
      log2(:,i2)
      log2(:,i3)
      log2(:,i4)
      H=trans(log2(1,i1),log2(2,i1),log1(1,i1),log1(2,i1),...
                      log2(1,i2),log2(2,i2),log1(1,i2),log1(2,i2),...
                      log2(1,i3),log2(2,i3),log1(1,i3),log1(2,i3),...
                      log2(1,i4),log2(2,i4),log1(1,i4),log1(2,i4));
      image_reference_modified=AlignImages(image_reference,image_original,H);
      [n,p]=size(image_reference);
      error_new=SquareError(image_reference,image_reference_modified,n,p);
      if(error_new<error)
         error_new=error;
         H_f=H;
      end
  end
  image_reference=AlignImages(image_reference,image_original,H_f);
end



function sum=SquareError(image1,image2,n,p)
  sum=0;
  for i=1:(n/10);
      for j=1:1:p/10
          sum=sum+(image1(i,j)-image2(i,j)).^2;
      end 
  end
end
                  
                  
                  
                  