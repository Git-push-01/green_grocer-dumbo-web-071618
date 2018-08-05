def consolidate_cart(cart)
  newHash = {}
  cart.each do |food, info|
      food.each do |a,b|
        if newHash[a]== nil
          newHash[a]={price: b[:price], clearance: b[:clearance], count: 1}
        else
          newHash[a][:count]+=1
        end
      end
  end
  return newHash
end

def getCouponCount(name,coupons)
  counter = 0
  coupons.each do |items|
    if items[:item] == name
      counter += 1
    end
  end
  return counter
end

def apply_coupons(cart, coupons)
	 couponHash = {}
	 amtHash = {}
	 cCart =  cart
	 if coupons == []
		 return cCart
	 end
	 cCart.each do |food, info|
		 coupons.each do |items|
			 if items[:item] == food
					 couponHash["#{food} W/COUPON"] = {:price => items[:cost], :clearance => info[:clearance], :count => getCouponCount(food,coupons)}
           couponHash["#{food}"] = {:price => info[:price], :clearance => info[:clearance], :count => info[:count] - (items[:num]*getCouponCount(food,coupons))}
			 end
		 end
	 end
	 return cCart.merge!(couponHash)
end

def apply_clearance(cart)
	cart.reject{|hash,info| info[:clearance]==false}.collect{|hash,info| info[:price]=((info[:price]*1.8)-info[:price]).round(1)}
  return cart
end

def checkout(cart, coupons)
  total = 0
	cCart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))

	cCart.each do |food,info|
	  if food == "BEER" || food == "BEER W/COUPON"
	    total += info[:price]*info[:count]
	  end
	end

	if total > 100
	  total =  ((total*1.9)-total).round(1)
	end

	return total
  # code here
end
